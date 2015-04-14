class TaskSerializer < ActiveModel::Serializer
  
  attributes :id, 
    :category, 
    :body

end
