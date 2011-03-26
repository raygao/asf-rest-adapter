#add-on-module
puts ' add_on_module loaded.......'
module Authenticate
  # instance method
  def Who?
    puts "calling who method of the GEM"
    "#{self.type.name}(\##{self.id}): #{self.to_s}"
  end

  #class methods
  def self.included(base)
    class << base
      def public_opbk_method
        puts "public static method called of the GEM"
      end
      def call_private
        private_method
      end
      private
      def private_method
        puts "private of the GEM"
      end
    end
  end

end