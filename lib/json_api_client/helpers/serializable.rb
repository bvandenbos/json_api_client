module JsonApiClient
  module Helpers
    module Serializable
      RESERVED = ['id', 'type', 'links', 'meta']

      # def as_json(options=nil)
      #   attributes.slice(*RESERVED).tap do |h|
      #     h['attributes'] = serialized_attributes
      #   end
      # end

      def data
        attributes.slice(*RESERVED).tap do |h|
          h['attributes'] = serialized_attributes
        end
      end

      # HACK: Currently, all the data is being passed back to the server during an update, including the links
      # which may contain "self" references.  This is breaking server implementations since it violates the JSONAPI spec.
      # As a work-around, we're stripping the self links.  A longer term solution would likely involve dirty tracking
      # on both attributes and fields to build the changes necessary to pass in the PATCH request.
      def data_for_update
        _data = data
        _data['links'].reject! { |k,v| k == 'self' } if _data['links']
        _data
      end

      def serialized_attributes
        attributes.except(*RESERVED)
      end

    end
  end
end
