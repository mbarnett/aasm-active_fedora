require 'rdf'
require 'sufia'

module AASM
  module Persistence
    module ActiveFedoraPersistence

      class AASMTerms < RDF::Vocabulary
        term :aasmstate
      end

      def self.included(base)
        base.send(:include, AASM::Persistence::Base)
        base.send(:include, AASM::Persistence::ActiveFedoraPersistence::InstanceMethods)

        attribute_name = base.send(:aasm, :default).attribute_name.to_sym
        # we need to add a backing-store property whose name is given to us by AASM, BUT AASM wants to own the
        # setter for it, and defines it before we get a chance to. Which is great EXCEPT that ActiveTriples
        # freaks out if that setter is already defined when you call property. Therefore we temporarily
        # hide the setter, define the property, and then put the setter back in place
        base.send(:alias_method, :temp_af_moveaside, "#{attribute_name}=")
        base.send(:remove_method, "#{attribute_name}=")

        base.send(:property, attribute_name, predicate: AASM::Persistence::ActiveFedoraPersistence::AASMTerms::aasmstate, multiple: false) do |index|
          index.as :stored_searchable
        end

        base.send(:alias_method, "#{attribute_name}=", :temp_af_moveaside)
        base.send(:remove_method, :temp_af_moveaside)

        base.after_initialize :aasm_ensure_initial_state

        # add the property to SolrDocuments as well
        Sufia::SolrDocumentBehavior.module_eval do
          define_method attribute_name do
            self[Solrizer.solr_name(attribute_name)]
          end
        end
      end

      module InstanceMethods

        def aasm_ensure_initial_state
          AASM::StateMachineStore.fetch(self.class, true).machine_names.each do |state_machine_name|
            if send(self.class.aasm(state_machine_name).attribute_name).nil?
              aasm(state_machine_name).enter_initial_state
            end
          end
        end

        def aasm_read_state(name=:default)
          current = send(self.class.aasm(name).attribute_name)
          return current.to_sym unless current.nil?

          initial_state = aasm(name).enter_initial_state
          set_value(self.class.aasm(name).attribute_name, initial_state)
          return initial_state
        end

        def aasm_write_state(new_state, name=:default)
          aasm_write_state_without_persistence(new_state, name)
          save
        end

        def aasm_write_state_without_persistence(new_state, name=:default)
          set_value(self.class.aasm(name).attribute_name, new_state)
        end
      end
    end
  end
end
