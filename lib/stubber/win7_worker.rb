
module Stubber
  class Win7Worker < Stubber::Worker

    # Decide if we find evidence of the installed sensor:
    def sensor_installed?(version: nil)
    end

    # Download and install the specified version of the sensor:
    def install_sensor!(version: :latest)
    end
  end
end
