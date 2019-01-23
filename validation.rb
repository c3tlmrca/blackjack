module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods

    base.instance_variable_set(:@validation, {})
  end

  module ClassMethods
    attr_reader :validation

    def validate(attr, type, arg = nil)
      @validation[attr] ||= {}
      @validation[attr][type] = arg
    end

    def inherited(subclass)
      dup = instance_variable_get(:@validation).dup
      dup = dup.each { |k, v| dup[k] = v.dup }
      subclass.instance_variable_set(:@validation, dup)
    end
  end

  module InstanceMethods
    def validate!
      self.class.validation.each do |attr, validation_type|
        validation_type.each do |type, arg|
          value = instance_variable_get("@#{attr}")
          send("validate_#{type}", value, arg)
        end
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def validate_format(attribute, format)
      raise "Аттрибут #{attribute} не соответствует формату #{format}." if attribute !~ format
    end

    def validate_positive(attribute, _)
      raise "#{attribute} не может быть отрицательным." if attribute.negative?
    end
  end
end
