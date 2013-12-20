require 'spec_helper'

describe Goal do

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:private) }
  it { should allow_mass_assignment_of(:completed) }
  it { should_not allow_mass_assignment_of(:user_id) }
  it { should belong_to(:user) }

end
