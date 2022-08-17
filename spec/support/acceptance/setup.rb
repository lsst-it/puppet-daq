# frozen_string_literal: true

# The rce service appears to have a hardwired check for the existence of an
# interface named lsst-daq and will fail to startup if it is not present.
script = <<~SH
  ip link add name lsst-daq link eth0 type dummy
  ip a add 192.168.42.1/24 dev lsst-daq
  ip link set lsst-daq up
SH

script.split("\n").each do |line|
  shell(line)
end
