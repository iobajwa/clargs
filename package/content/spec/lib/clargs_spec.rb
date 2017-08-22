
require "spec_helper"
require "clargs"

describe CLArgs do
	describe "when parsing options from the passed string, returns correct options when" do
		it "a simple flag is passed" do
			options, files = CLArgs.parse "--flag"
			files.should be_empty
			options.should be == { :flag => nil }
		end
		it "multiple flags are passed" do
			options, files = CLArgs.parse ["--flag1", "-- flag2", "  -- flag3  "]
			files.should be_empty
			options.should be == { :flag1 => nil, :flag2 => nil, :flag3 => nil }
		end
		it "single key-value is provided" do
			arg = "--key=value"
			arg = arg.freeze
			options, files = CLArgs.parse ["a", "", "  ", arg]

			files.should be == ["a"]
			options.should be == { :key => "value" }
			# check against freeze
			options[:key] += "_add"
			options[:key].should be == "value_add"
		end
		it "single key-value is provided with multiple values" do
			options, files = CLArgs.parse ["--key=v1;v2"]
			files.should be_empty
			options.should be == { :key => ["v1", "v2"] }
		end
		it "multiple key-values are provided with multiple values" do
			options, files = CLArgs.parse ["--k1=v1;", " -- k2 =2; -3; ", "  -- k3 = v4 ;  ", " --k4=23  ",  " --  k5 =   -23" ]
			files.should be_empty
			options.should be == { :k1 => "v1", :k2 => [ 2, -3 ], :k3 => "v4", :k4 => 23, :k5 =>-23 }
		end
	end
end
