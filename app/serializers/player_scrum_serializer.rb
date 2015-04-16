class PlayerScrumSerializer < ActiveModel::Serializer

  attributes :name, :entries


  def entries
    "test"
    # object.entries.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day).group_by { |x| x.category }
  end

end
