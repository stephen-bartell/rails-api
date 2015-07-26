# == Schema Information
#
# Table name: scrums
#
#  id         :uuid             not null, primary key
#  team_id    :uuid
#  date       :date
#  points     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Scrum < ActiveRecord::Base

  belongs_to :team
  has_many :entries
  has_many :players, through: :entries

  scope :today, -> { where(date: Date.today) }

  def entries_due_at
    cron = CronParser.new(self.team.summary_at)
    due_at = cron.next(created_at.beginning_of_day)
    due_at.change(year: date.year, month: date.month, day: date.day)

    ActiveSupport::TimeZone.new(team.timezone).local_to_utc(due_at)
  end

  def entries_allowed_after
    ActiveSupport::TimeZone.new(team.timezone).local_to_utc(created_at.beginning_of_day)
  end

  def tally
    update_column :points, entries.sum(:points)
  end

  def tally_points_for_player(player)
    entries.where(player_id: player.id).sum(:points)
  end

  def serialized_players
    filed = []
    not_filed = []

    team.players.uniq.map do |player|
      begin
        # Group the entries by category
        categories = Entry.where(scrum_id: id, player_id: player.id).group_by { |entry| entry[:category] }
        created_at = Entry.where(scrum_id: id, player_id: player.id).order(created_at: :desc).last.created_at
        filed <<  {
          id: player.id,
          email: player.email,
          slack_id: player.slack_id,
          name: player.name,
          real_name: player.real_name,
          points: player.points,
          points_today: tally_points_for_player(player),
          created_at: created_at,
          categories: categories.map { |category, entries| {
            category: category,
            entries: entries.map { |entry| entry.slice(:body, :points) }
          }}
        }
      rescue
        not_filed <<  {
          id: player.id,
          email: player.email,
          slack_id: player.slack_id,
          name: player.name,
          real_name: player.real_name,
          points: player.points,
          points_today: tally_points_for_player(player),
        }
      end
    end

    {
      filed: filed,
      not_filed: not_filed
    }
  end

  # FIXME: do this in a sane way
  def recipient_variables
    Hash[ *team.players.uniq.collect { |v| [ v.email, {name: v.name, points: tally_points_for_player(v)} ] }.flatten ]
  end

  def deliver_summary_email
    recipients = team.players.uniq

    to = recipients.map {|recipient| "#{recipient.real_name} <#{recipient.email}>" }

    text_path = Rails.root.join('lib/mailers/summary.text')
    text = Mustache.render(File.read(text_path), players: serialized_players)

    # TODO: Fix html template
    html_path = Rails.root.join('lib/mailers/summary.html')
    html = Mustache.render(File.read(html_path), players: serialized_players)

    if entries.count > 0
      RestClient.post ENV['MAILGUN_URL'],
          "from"     => "Scrum Bot <bot@astroscrum.com>",
          "to"       => to.join(','),
          "subject"  => "[Astroscrum] Summary for team #{team.name} - #{date}",
          "text"     => text,
          "html"     => html,
          "recipient-variables" => recipient_variables.to_json
    else
      RestClient.post ENV['MAILGUN_URL'],
          "from"     => "Scrum Bot <bot@astroscrum.com>",
          "to"       => to.join(','),
          "subject"  => "[Astroscrum] Nobody on your team did their scrum today ಠ_ಠ",
          "text"     => "ಠ_ಠ",
          "html"     => "ಠ_ಠ",
          "recipient-variables" => recipient_variables.to_json
    end

  end

end
