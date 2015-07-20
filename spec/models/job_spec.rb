# == Schema Information
#
# Table name: jobs
#
#  id                   :integer          not null, primary key
#  jid                  :string
#  method_string        :string           not null
#  reoccurrence_crontab :string
#  run_at               :datetime
#  run_count            :integer          default(1)
#  status               :string
#  resource_id          :uuid
#  resource_type        :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'rails_helper'

RSpec.describe Job, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
