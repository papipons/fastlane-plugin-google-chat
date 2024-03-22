  require 'fastlane/action'
  require_relative '../helper/google_chat_helper'
  require 'net/http'
  require 'uri'
  require 'json'
  
  module Fastlane
    module Actions
      class GoogleChatAction < Action
        def self.run(params)
          uri = URI.parse(params[:webhook])

          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER

          bodyString = <<~HEREDOC
          Distributed App
          App Name: *New GlobeOne*
          Platform: *#{params[:platform]}*
          
          Version: *#{params[:versionText]}*
          CXS: *#{params[:cxsEnv]}*
          Catalog: *#{params[:catalogEnv]}*
          CMS: *#{params[:cmsVersionText]}*
          Debug Menu: *#{params[:debugMenuText]}*
          Git Branch: *#{params[:gitBranch]}*
          
          *Release Notes:*
          -
          
          _#{params[:footerText]}_
          HEREDOC

          bodyText = {
            text: bodyString
          }

          # Chat Request
          messageRequest = Net::HTTP::Post.new(uri.request_uri)
          messageRequest["Content-Type"] = "application/json"
          messageRequest.body = bodyText.to_json

          # Send Chat Request
          chatResponse = http.request(messageRequest)
        end
        
        def self.description
          "Send messages to Google Chat"
        end
        
        def self.authors
          ["Alfonse Dumadapat"]
        end
        
        def self.return_value
          # If your method provides a return value, you can describe here what it does
        end
        
        def self.details
          # Optional:
          "Send messages to Google Chat rooms"
        end
        
        def self.available_options
          [
            FastlaneCore::ConfigItem.new(key: :webhook,
                                    env_name: "GOOGLE_CHAT_webhook",
                                 description: "Google chat space webhook",
                                    optional: false,
                                        type: String),
            FastlaneCore::ConfigItem.new(key: :platform,
                                    env_name: "GOOGLE_CHAT_platform",
                                 description: "Platform",
                                    optional: false,
                                        type: String),
            FastlaneCore::ConfigItem.new(key: :versionText,
                                    env_name: "GOOGLE_CHAT_versionText",
                                 description: "Version Text",
                                    optional: false,
                                        type: String),
            FastlaneCore::ConfigItem.new(key: :cxsEnv,
                                    env_name: "GOOGLE_CHAT_cxsEnv",
                                 description: "CXS Environment",
                                    optional: false,
                                        type: String),
            FastlaneCore::ConfigItem.new(key: :catalogEnv,
                                    env_name: "GOOGLE_CHAT_catalogEnv",
                                 description: "Catalog Environment",
                                    optional: false,
                                        type: String),
            FastlaneCore::ConfigItem.new(key: :cmsVersionText,
                                    env_name: "GOOGLE_CHAT_cmsVersionText",
                                 description: "CMS Version Text",
                                    optional: false,
                                       type: String),
            FastlaneCore::ConfigItem.new(key: :debugMenuText,
                                    env_name: "GOOGLE_CHAT_debugMenuText",
                                 description: "Debug Menu Text",
                                    optional: false,
                                        type: String),
            FastlaneCore::ConfigItem.new(key: :footerText,
                                    env_name: "GOOGLE_CHAT_footerText",
                                 description: "Footer text",
                                    optional: false,
                                        type: String),
            FastlaneCore::ConfigItem.new(key: :gitBranch,
                                    env_name: "GOOGLE_CHAT_gitBranch",
                                 description: "Git Branch",
                                    optional: false,
                                        type: String)
          ]
        end
        
        def self.is_supported?(platform)
          # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
          # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
          #
          [:ios, :mac, :android].include?(platform)
          true
        end
      end
    end
  end
  