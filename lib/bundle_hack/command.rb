# frozen_string_literal: true

module BundleHack
  class Command < Bundler::Plugin::API
    command 'hack'
    command 'hack:restore'
    command 'hack:restore:all'

    def exec(command, args)
      Sandbox.new(args.first).create if command == 'hack'
    end
  end
end
