class CLArgs
	def CLArgs.parse(args)
		args = [args] if args.class != Array
		options = {}
		filelist = []
		args.each {  |arg|
			arg = arg.strip
			if (arg =~ /^--([a-zA-Z+0-9._\\\/:\s]+)=\"?([a-zA-Z+0-9._\\\/:\s\;]+)\"?/)  # match against "--key=value"
				options = option_maker(options, $1, $2)
			elsif (arg =~ /^--([a-zA-Z+0-9._\\\/:\s]+)/) # match agains "--key"
				options = option_maker(options, $1, $2)
			else
			filelist << arg
			end
		}
		return options, filelist
	end

	private
	def CLArgs.option_maker(options, key, val)
		options = options || {}
		key = key.strip.to_sym
		# val = "" if val == nil
		if val == nil
			options[key] = nil
			return options
		end
		options[key] =
		if val.chr == ":"
			val[1..-1].to_sym
		elsif val.include? ";"
			# appends the array values to previously parsed values
			value = options[key]
			value = [] unless value
			value.push val.split(';').map(&:strip)
			value.flatten!
			value = value[0] if value.length == 1
			value
		elsif val == 'true'
			true
		elsif val == 'false'
			false
		elsif val =~ /^\d+$/
			val.to_i
		else
			val
		end
		return options
	end
	
end
