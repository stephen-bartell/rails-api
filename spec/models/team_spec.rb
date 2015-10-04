# == Schema Information
#
# Table name: teams
#
#  id                  :uuid             not null, primary key
#  name                :string
#  auth_token          :string
#  points              :integer          default(0)
#  slack_id            :string
#  bot_url             :string
#  prompt_at           :string
#  prompt_jid          :string
#  remind_at           :string
#  remind_jid          :string
#  summary_at          :string
#  summary_jid         :string
#  timezone            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  do_not_disturb_days :text             default(["6", "7"]), is an Array
#

require 'rails_helper'

RSpec.describe Team, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
