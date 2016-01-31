# => This is the server for the Sistributed File Sharing System
# => The server manages everything. The client sends the file, line by line.
# => Each line is checked against the current version, if the line is changed, save the new version.
# => In the case that multiple clients are altering the same file...

require 'stringio'

# => Global variables
number = 0

class DFS

	def CreateFile
		# => This creates a file for this user. Numbered specifically for this user.
		number++#Move onto next number

		fname = "File" + number + ".txt"

		# => Check if the file exists already (from previos sessions)
		if !File.exist?(fname)
			# => Create the file if it doesn't
			file = File.new("out.txt", "w")
			file.close
		end

		return number
	end

	def readline(line, line_number, thisfile)
		# => Place the new line in position.

		fname = "File" + thisfile + ".txt"

		count = 0
		tmp = StringIO.open
		origin.each do |line_two|
  			if count == line_number# => Replace line X
    			tmp << line
    		else# => Just copy the unaltered lines in.
    			tmp << line_two
  			end
		end
		tmp.seek(0)
		File.open(fname, "wb").write tmp.read

	end

	def Merge(thisfile)
		#This method merges multiple files,
		#The client has it's own files, merging into the one real file.

		fname = "File" + thisfile + ".txt"
		tmp = ""
		tmp_two = ""
		tmp_mid = ""
  		tmp_end = ""

		f0 = File.open("File.txt", 'r')
		f1 = File.open(fname, 'r')

		f0.each.zip(f1.each).each do |line0, line1|
  			#Compare each line.
  			if line0 == line1
  				# If they equal, do nothing
  				tmp << line0
  			else #Otherwise, you have to Merge the lines...
  				tmp_two = ""
  				tmp_mid = ""
  				tmp_end = ""

  				count = 0
  				max_f0 = line0.lenght
  				max_f1 = line1.lenght

  				while (count < line1.max_f1 && count < line0.lenght)
  					if line1[count, count+1] == line0[count, count+1]
  						tmp_two << line0[count, count+1]
  					else
  						break
  					end
  					count++
  				end

  				# => Got the first part, as far as we can go
  				# => Now from the end
  				while (max_f0 > count && max_f1 > count)
  					if line0[max_f0-1, max_f0] == line1[max_f1-1, max_f1]
  						tmp_end = tmp_end + line0[max_f0-1, max_f0]
  					else
  						break
  					end
  					max_f0--
  					max_f1--
  				end

  				# => We have the start and end,
  				# => Now the hard part, the middle.
  				# => Merge the two substrings into one string.
  				while (count < max_f0 && count < max_f1)

  					
  					
  					count++
  				end


  				# => Append middle and end to start
  				tmp_two << tmp_mid << tmp_end
  				# Put the whole line together
  				tmp << tmp_two
  			end
		end

		f0.close
		f1.close

		#Open both files, and overwrite.
		tmp.seek(0)
		File.open("File.txt", "wb").write tmp.read
		tmp.seek(0)
		File.open(fname, "wb").write tmp.read
		
	end

end

#Main

object = DFS.new

DRb.start_service('druby://localhost:9999', object)#Connect class to address
DRb.thread.join#Wait for client to connect

#End
