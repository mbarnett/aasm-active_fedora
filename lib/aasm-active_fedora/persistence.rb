require 'pry'
module AASM
  module PersistenceWithActiveFedora
    module ClassMethods
      def load_persistence(base)
        hierarchy = base.ancestors.map {|klass| klass.to_s}
        if hierarchy.include?('ActiveFedora::Base')
          include_persistence base, :active_fedora
        else
          super
        end
      end
    end

    def self.prepended(base)
      class << base
        prepend ClassMethods
      end
    end
  end
end

AASM::Persistence.send(:prepend, AASM::PersistenceWithActiveFedora)
