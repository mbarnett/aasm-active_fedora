module AASM
  module PersistenceWithActiveFedora
    def load_persistence(base)
      hierarchy = base.ancestors.map {|klass| klass.to_s}
      if hierarchy.include?('ActiveFedora::Base')
        include_persistence base, :active_fedora
      else
        super
      end
    end
  end
end

AASM::Persistence.send(:prepend, AASM::PersistenceWithActiveFedora)
