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
          cardsV2 = {
            "cardsV2": [
              {
                "card": {
                  "header": {
                    "title": params[:headerTitle],
                    "subtitle": params[:headerSubtitle]
                  },
                  "sections": [
                    {
                      "widgets": [
                      {
                        "decoratedText": {
                          "topLabel": "<font color=\"#4caf50\">#{params[:item1Title]}</font>",
                          "text": params[:item1Subtitle]
                        }
                      },
                      {
                        "decoratedText": {
                          "topLabel": "<font color=\"#4caf50\">#{params[:item2Title]}</font>",
                          "text": params[:item2Subtitle]
                        }
                      },
                      {
                        "decoratedText": {
                          "topLabel": "<font color=\"#4caf50\">#{params[:item3Title]}</font>",
                          "text": params[:item3Subtitle]
                        }
                      },
                      {
                        "decoratedText": {
                          "topLabel": "<font color=\"#4caf50\">#{params[:item4Title]}</font>",
                          "text": params[:item4Subtitle]
                        }
                      },
                      {
                        "divider": {}
                      },
                      {
                        "buttonList": {
                          "buttons": [
                            {
                              "text": params[:buttonTitle],
                              "color": {
                                "red": 0.29,
                                "green": 0.69,
                                "blue": 0.31,
                                "alpha": 1
                              },
                              "onClick": {
                                "openLink": {
                                  "url": params[:buttonUrl]
                                }
                              }
                            }
                          ]
                        }
                      }
                    ]
                    }
                  ]
                }
              }
            ]
          }

          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true

          request = Net::HTTP::Post.new(uri.request_uri)
          request["Content-Type"] = "application/json"
          request.body = cardsV2.to_json

          response = http.request(request)

          UI.message("Message sent!")
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
            FastlaneCore::ConfigItem.new(
              key: :webhook,    
              env_name: "GOOGLE_CHAT_webhookl",
              description: "Webhook URL",
              optional: false,                          
              type: String
            ),
            FastlaneCore::ConfigItem.new(
              key: :headerTitle,                      
              env_name: "GOOGLE_CHAT_headerTitle",
              description: "Header title",
              optional: false,
              type: String
            ),
            FastlaneCore::ConfigItem.new(
              key: :headerSubtitle,
              env_name: "GOOGLE_CHAT_headerSubtitle",
              description: "Header subtitle",
              optional: false,
              type: String
            ),    

            FastlaneCore::ConfigItem.new(
              key: :item1Title,
              env_name: "GOOGLE_CHAT_item1Title",
              description: "Item 1 title",
              optional: false,
              type: String
            ),
            FastlaneCore::ConfigItem.new(
              key: :item1Subtitle,
              env_name: "GOOGLE_CHAT_item1Subtitle",
              description: "Item 1 subtitle",
              optional: false,
              type: String
            ),
            FastlaneCore::ConfigItem.new(
              key: :item2Title,
              env_name: "GOOGLE_CHAT_item2Title",
              description: "Item 2 title",
              optional: false,
              type: String
            ),
            FastlaneCore::ConfigItem.new(
              key: :item2Subtitle,
              env_name: "GOOGLE_CHAT_item2Subtitle",
              description: "Item 2 subtitle",
              optional: false,
              type: String
            ),
            FastlaneCore::ConfigItem.new(
              key: :item3Title,
              env_name: "GOOGLE_CHAT_item3Title",
              description: "Item 3 title",
              optional: false,
              type: String
            ),
            FastlaneCore::ConfigItem.new(
              key: :item3Subtitle,
              env_name: "GOOGLE_CHAT_item3Subtitle",
              description: "Item 3 subtitle",
              optional: false,
              type: String
            ),
            FastlaneCore::ConfigItem.new(
              key: :item4Title,
              env_name: "GOOGLE_CHAT_item4Title",
              description: "Item 4 title",
              optional: false,
              type: String
            ),
            FastlaneCore::ConfigItem.new(
              key: :item4Subtitle,
              env_name: "GOOGLE_CHAT_item4Subtitle",
              description: "Item 4 subtitle",
              optional: false,
              type: String
            ),

            FastlaneCore::ConfigItem.new(
              key: :buttonTitle,
              env_name: "GOOGLE_CHAT_buttonTitle",
              description: "Button title",
              optional: false,
              type: String
            ),
            FastlaneCore::ConfigItem.new(
              key: :buttonUrl,
              env_name: "GOOGLE_CHAT_buttonUrl",
              description: "Button URL",
              optional: false,
              type: String
            )
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
  