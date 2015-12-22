def get_local_timezone_str
  # Yes, this is actually a shell script…
  olsontz = `if [ -f /etc/timezone ]; then
    cat /etc/timezone
  elif [ -h /etc/localtime ]; then
    readlink /etc/localtime | sed "s/\\/usr\\/share\\/zoneinfo\\///"
  else
    checksum=\`md5sum /etc/localtime | cut -d' ' -f1\`
    find /usr/share/zoneinfo/ -type f -exec md5sum {} \\; | grep "^$checksum" | sed "s/.*\\/usr\\/share\\/zoneinfo\\///" | head -n 1
  fi`.chomp

  # return UTC if unsure
  return "UTC" if olsontz.nil? || olsontz.empty?
  return olsontz
end

Facter.add(:olson_timezone) do
  setcode do
    get_local_timezone_str
  end
end
