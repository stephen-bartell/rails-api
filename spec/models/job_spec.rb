# == Schema Information
#
# Table name: jobs
#
#  id                   :integer          not null, primary key
#  jid                  :string
#  method_string        :string
#  reoccurrence_crontab :string
#  run_at               :datetime
#  run_count            :integer
#  status               :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'rails_helper'

RSpec.describe Job, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
