class ScrumSerializer < ActiveModel::Serializer

  attributes :id, :date, :points, :players

  def players
    puts "=============================="

    [
      {
        name: 'jpsilvashy',
        entries: {
          today: [],
          yesterday: [],
          blocked: []
        }
      },{
        name: 'someone',
        entries: {
          today: [],
          yesterday: [],
          blocked: []
        }
      }
    ]
  end

  # has_many :players, serializer: PlayerScrumSerializer

end
