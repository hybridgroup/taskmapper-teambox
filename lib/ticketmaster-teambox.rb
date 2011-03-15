require File.dirname(__FILE__) + '/teambox/teambox-api'

%w{ teambox ticket project comment }.each do |f|
  require File.dirname(__FILE__) + '/provider/' + f + '.rb';
end
