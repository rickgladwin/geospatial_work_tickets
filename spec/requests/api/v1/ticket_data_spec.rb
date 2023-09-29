require 'swagger_helper'

RSpec.describe 'api/v1/ticket_data', type: :request do

  path '/api/v1/ticket_data' do

    post('input ticket_datum') do
      consumes 'application/json'

      parameter name: :ticket_data_json, in: :body, schema: {
        RequestNumber:  { type: :string },
        SequenceNumber: { type: :string },
        RequestType:    { type: :string },
        RequestAction:  { type: :string },
        DateTimes:      {
          ResponseDueDateTime: { type: :date_time },
        },
        ServiceArea:    {
          PrimaryServiceAreaCode:     {
            SACode: { type: :string },
          },
          AdditionalServiceAreaCodes: {
            SACode: { type: :array },
          }
        },
        Excavator:      {
          CompanyName: { type: :string },
          Address:     { type: :string },
          City:        { type: :string },
          State:       { type: :string },
          Zip:         { type: :string },
          CrewOnsite:  { type: :boolean },
        },
        ExcavationInfo: {
          DigsiteInfo: {
            WellKnownText: { type: :string }
          }
        }
      }

      response(201, 'Ticket and Excavator created') do
        let(:ticket_data_json) do
          {
            "RequestNumber":  "09252012-00001",
            "SequenceNumber": "2421",
            "RequestType":    "Normal",
            "RequestAction":  "Restake",
            "DateTimes":      {
              "ResponseDueDateTime": "2011/07/13 23:59:59",
            },
            "ServiceArea":    {
              "PrimaryServiceAreaCode":     {
                "SACode": "ZZGL103"
              },
              "AdditionalServiceAreaCodes": {
                "SACode": %w[ZZL01 ZZL02 ZZL03]
              }
            },
            "Excavator":      {
              "CompanyName": "John Doe CONSTRUCTION",
              "Address":     "555 Some RD",
              "City":        "SOME PARK",
              "State":       "ZZ",
              "Zip":         "55555",
              "CrewOnsite":  "true"
            },
            "ExcavationInfo": {
              "DigsiteInfo": {
                "WellKnownText": "POLYGON((32.07206917625161 -81.13390268058475,32.04064386441295 -81.14660562247929,32.02259853170128 -81.08858407706913,32.02434500961698 -81.05322183341679,32.042681017283066 -81.05047525138554,32.06537765335268 -81.0319358226746,32.078469305179404 -81.01202310294804,32.07963291684719 -81.02850259513554,32.07090546831167 -81.07759774894413,32.08806865844325 -81.12154306144413,32.07206917625161 -81.13390268058475))"
              }
            }
          }
        end

        after do |example|
          example.metadata[:response][:content] = {
            'text/plain' => {
              example: response.body
            }
          }
        end
        run_test!
      end

      response(400, 'Invalid polygon (WellKnownText) data') do
        let(:ticket_data_json) do
          {
            "RequestNumber":  "09252012-00001",
            "SequenceNumber": "2421",
            "RequestType":    "Normal",
            "RequestAction":  "Restake",
            "DateTimes":      {
              "ResponseDueDateTime": "2011/07/13 23:59:59",
            },
            "ServiceArea":    {
              "PrimaryServiceAreaCode":     {
                "SACode": "ZZGL103"
              },
              "AdditionalServiceAreaCodes": {
                "SACode": %w[ZZL01 ZZL02 ZZL03]
              }
            },
            "Excavator":      {
              "CompanyName": "John Doe CONSTRUCTION",
              "Address":     "555 Some RD",
              "City":        "SOME PARK",
              "State":       "ZZ",
              "Zip":         "55555",
              "CrewOnsite":  "true"
            },
            "ExcavationInfo": {
              "DigsiteInfo": {
                "WellKnownText": "INVALID((32.07206917625161 -81.13390268058475,32.04064386441295 -81.14660562247929,32.02259853170128 -81.08858407706913,32.02434500961698 -81.05322183341679,32.042681017283066 -81.05047525138554,32.06537765335268 -81.0319358226746,32.078469305179404 -81.01202310294804,32.07963291684719 -81.02850259513554,32.07090546831167 -81.07759774894413,32.08806865844325 -81.12154306144413,32.07206917625161 -81.13390268058475))"
              }
            }
          }
        end

        after do |example|
          example.metadata[:response][:content] = {
            'text/plain' => {
              example: response.body
            }
          }
        end
        run_test!
      end

      response(400, 'Invalid Ticket data') do
        let(:ticket_data_json) do
          {
            "RequestNumber":  "09252012-00001",
            "SequenceNumber": "2421",
            "RequestType":    "Normal",
            "RequestAction":  "Restake",
            "DateTimes":      {
              "ResponseDueDateTime": "2011/07/13 23:59:59",
            },
            "ServiceArea":    {
              "PrimaryServiceAreaCode":     {
                "SACode": "ZZGL103"
              },
              "AdditionalServiceAreaCodes": {
                "SACode": %w[ZZL01 ZZL02 ZZL03]
              }
            },
            "Excavator":      {
              "CompanyName": "John Doe CONSTRUCTION",
              "Address":     "555 Some RD",
              "City":        "SOME PARK",
              "State":       "ZZ",
              "Zip":         "55555",
              "CrewOnsite":  "true"
            },
            "ExcavationInfo": {
              "DigsiteInfo": {
                "WellKnownText": "INVALID((32.07206917625161 -81.13390268058475,32.04064386441295 -81.14660562247929,32.02259853170128 -81.08858407706913,32.02434500961698 -81.05322183341679,32.042681017283066 -81.05047525138554,32.06537765335268 -81.0319358226746,32.078469305179404 -81.01202310294804,32.07963291684719 -81.02850259513554,32.07090546831167 -81.07759774894413,32.08806865844325 -81.12154306144413,32.07206917625161 -81.13390268058475))"
              }
            }
          }
        end

        after do |example|
          example.metadata[:response][:content] = {
            'text/plain' => {
              example: response.body
            }
          }
        end
        run_test!
      end

      response(400, 'Invalid Excavator data') do
        let(:ticket_data_json) do
          {
            "RequestNumber":  "09252012-00001",
            "SequenceNumber": "2421",
            "RequestType":    "Normal",
            "RequestAction":  "Restake",
            "DateTimes":      {
              "ResponseDueDateTime": "2011/07/13 23:59:59",
            },
            "ServiceArea":    {
              "PrimaryServiceAreaCode":     {
                "SACode": "ZZGL103"
              },
              "AdditionalServiceAreaCodes": {
                "SACode": %w[ZZL01 ZZL02 ZZL03]
              }
            },
            "Excavator":      {
              "CompanyName": "",
              "Address":     "555 Some RD",
              "City":        "SOME PARK",
              "State":       "ZZ",
              "Zip":         "55555",
              "CrewOnsite":  "true"
            },
            "ExcavationInfo": {
              "DigsiteInfo": {
                "WellKnownText": "POLYGON((32.07206917625161 -81.13390268058475,32.04064386441295 -81.14660562247929,32.02259853170128 -81.08858407706913,32.02434500961698 -81.05322183341679,32.042681017283066 -81.05047525138554,32.06537765335268 -81.0319358226746,32.078469305179404 -81.01202310294804,32.07963291684719 -81.02850259513554,32.07090546831167 -81.07759774894413,32.08806865844325 -81.12154306144413,32.07206917625161 -81.13390268058475))"
              }
            }
          }
        end

        after do |example|
          example.metadata[:response][:content] = {
            'text/plain' => {
              example: response.body
            }
          }
        end
        run_test!
      end
    end
  end
end
