module AASM
  module Persistence
    class << self
      def load_persistence_with_active_fedora(base)
        hierarchy = base.ancestors.map {|klass| klass.to_s}
        if hierarchy.include?('ActiveFedora::Base')
          include_persistence base, :active_fedora
        else
          load_persistence_without_active_fedora(base)
        end
      end

      alias_method_chain :load_persistence, :active_fedora
    end
  end
end
