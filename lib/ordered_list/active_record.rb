require "ordered_list/active_record/balancing"
require "ordered_list/active_record/orderable"
require "ordered_list/active_record/reorderable"
require "ordered_list/active_record/list"
require "ordered_list/active_record/dsl"

module OrderedList
  module ActiveRecord
    class << self
      def initialize!
        ::ActiveRecord::Base.extend DSL
        ::ActiveRecord::Base.class_attribute :position_column, :list_scope_columns
        ::ActiveRecord::Base.position_column = :position
        ::ActiveRecord::Base.list_scope_columns = []
      end
    end
  end
end
