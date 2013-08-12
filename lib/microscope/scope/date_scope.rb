module Microscope
  class Scope
    class DateScope < Scope
      def apply
        cropped_field = field.name.gsub(/_on$/, '')

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope "#{cropped_field}_before", lambda { |time| where("#{field.name} < ?", time) }
          scope "#{cropped_field}_before_or_on", lambda { |time| where("#{field.name} <= ?", time) }
          scope "#{cropped_field}_before_today", lambda { where("#{field.name} < ?", Date.today) }

          scope "#{cropped_field}_after", lambda { |time| where("#{field.name} > ?", time) }
          scope "#{cropped_field}_after_or_at", lambda { |time| where("#{field.name} >= ?", time) }
          scope "#{cropped_field}_after_today", lambda { where("#{field.name} > ?", Date.today) }

          scope "#{cropped_field}_between", lambda { |range| where("#{field.name}" => range) }

          scope "#{cropped_field}", lambda { where("#{field.name} IS NOT NULL AND #{field.name} <= ?", Date.today) }
          scope "not_#{cropped_field}", lambda { where("#{field.name} IS NULL OR #{field.name} > ?", Date.today) }
        RUBY
      end
    end
  end
end