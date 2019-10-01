# frozen_string_literal: true

json.array! @application_keys, partial: 'application_keys/application_key', as: :application_key
