require 'spec_helper'

describe Cheer do

  it { should belong_to(:user) }
  it { should belong_to(:goal) }

end
