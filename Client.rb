# => This is the client of the System.
# => The clients job is to simply send the file that is being used, line by line, 
# To the RM server.

require 'drb/drb' # => Distributed ruby, built in ruby that allows methods to be called across machines.

number = 0

def SendFile (x)
#Send the file over.
	file = File.new("File.txt", "r")#Open file, read only
	count = 0;
	while (line = file.gets)#Send a line over to the server, as well as the line number.
		x.readline(line, count, number)#Call method in server.
		count++#Increment for next line
	end
	file.close#Close file when done

	#Once the file has been uploaded, so all is correct, Merge with the main file
	x.Merge(number)

end

#Main
# proxies all method calls to the object we shared in server.rb
DRb.start_service 
remote_object = DRbObject.new_with_uri('druby://localhost:9999')

number = remote_object.CreateFile

while(true)
	SendFile(remote_object)
end

#End
