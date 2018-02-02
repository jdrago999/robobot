
module Stubber
  module Worker
    class << self
      def included(base)
        base.extend ClassMethods
      end
    end

    module ClassMethods

      def perform(args={})
        return_path = args.fetch('return_path')
        command_args = args.fetch('args')
        begin
          result = self.new.perform(command_args)

        rescue => e
          status = :error
          error = e
        end
      end

    end
  end
end
