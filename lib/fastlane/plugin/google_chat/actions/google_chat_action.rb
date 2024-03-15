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
          cards = {
              cards: [
              {
                header: {
                  title: params[:headerTitle],
                  subtitle: params[:headerSubTitle],
                  imageUrl: params[:headerImageUrl]
                },
                sections: [
                  {
                    widgets: [
                      {
                        keyValue: {
                          topLabel: params[:bodyTitle1],
                          content: "<b>#{params[:bodySubtitle1]}</b>"
                        }
                      },
                      {
                        keyValue: {
                          topLabel: params[:bodyTitle2],
                          content: "<b>#{params[:bodySubtitle2]}</b>"
                        }
                      },
                      {
                        keyValue: {
                          topLabel: params[:bodyTitle3],
                          content: "<b>#{params[:bodySubtitle3]}</b>"
                        }
                      },
                      {
                        keyValue: {
                          topLabel: params[:bodyTitle4],
                          content: "<b>#{params[:bodySubtitle4]}</b>"
                        }
                      }
                    ]
                  }
                ]
              }
            ]
          }
          # Create the HTTP objects
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER

          # Card Request
          cardRequest = Net::HTTP::Post.new(uri.request_uri)
          cardRequest["Content-Type"] = "application/json"
          cardRequest.body = cards.to_json
          
          # Send Card Request
          cardResponse = http.request(cardRequest)
          UI.message("Card Message sent!")

          # Chat Body
          bodyString = params[:mentions]
            .split(',')
            .map { |id| "<users/#{id}>" }
            .join(' ')

          if !bodyString.to_s.strip.empty?
            UI.message("Tagging people...")

            bodyText = {
              text: bodyString
            }

            # Chat Request
            messageRequest = Net::HTTP::Post.new(uri.request_uri)
            messageRequest["Content-Type"] = "application/json"
            messageRequest.body = bodyText.to_json

            # Send Chat Request
            chatResponse = http.request(messageRequest)
            UI.message("Tagging people was successful!")
          end
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
            FastlaneCore::ConfigItem.new(key: :headerTitle,
                                    env_name: "GOOGLE_CHAT_headerTitle",
                                 description: "Card header title",
                                    optional: false,
                                        type: String),
            FastlaneCore::ConfigItem.new(key: :headerSubTitle,
                                    env_name: "GOOGLE_CHAT_headerSubTitle",
                                 description: "Card header subtitle",
                                    optional: false,
                                        type: String),
            FastlaneCore::ConfigItem.new(key: :headerImageUrl,
                                    env_name: "GOOGLE_CHAT_headerImageUrl",
                                 description: "Card header image url",
                                    optional: false,
                                        type: String),

            FastlaneCore::ConfigItem.new(key: :bodyTitle1,
                                    env_name: "GOOGLE_CHAT_bodyTitle1",
                                 description: "Card body section 1 title",
                                    optional: false,
                                        type: String),
            FastlaneCore::ConfigItem.new(key: :bodySubtitle1,
                                    env_name: "GOOGLE_CHAT_bodySubitle1",
                                 description: "Card body section 1 subtitle",
                                    optional: false,
                                       type: String),

            FastlaneCore::ConfigItem.new(key: :bodyTitle2,
                                    env_name: "GOOGLE_CHAT_bodyTitle2",
                                 description: "Card body section 2 title",
                                    optional: false,
                                        type: String),
            FastlaneCore::ConfigItem.new(key: :bodySubtitle2,
                                    env_name: "GOOGLE_CHAT_bodySubtitle2",
                                 description: "Card body section 2 subtitle",
                                    optional: false,
                                        type: String),

            FastlaneCore::ConfigItem.new(key: :bodyTitle3,
                                    env_name: "GOOGLE_CHAT_bodyTitle3",
                                 description: "Card body section 3 title",
                                    optional: false,
                                        type: String),
            FastlaneCore::ConfigItem.new(key: :bodySubtitle3,
                                    env_name: "GOOGLE_CHAT_bodySubtitle3",
                                 description: "Card body section 3 subtitle",
                                    optional: false,
                                        type: String),

          FastlaneCore::ConfigItem.new(key: :bodyTitle4,
                                    env_name: "GOOGLE_CHAT_bodyTitle4",
                                 description: "Card body section 4 title",
                                    optional: false,
                                        type: String),
            FastlaneCore::ConfigItem.new(key: :bodySubtitle4,
                                    env_name: "GOOGLE_CHAT_bodySubtitle4",
                                 description: "Card body section 4 subtitle",
                                    optional: false,
                                        type: String),

            FastlaneCore::ConfigItem.new(key: :mentions,
                                    env_name: "GOOGLE_CHAT_metions",
                                 description: "Comma separated IDs of the people to be mentioned",
                                    optional: false,
                                        type: String),
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
  