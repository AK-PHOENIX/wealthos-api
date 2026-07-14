module API
  module V1
    module Market
      class Rates < Grape::API
        resource :rates do
          desc 'Get USD to INR rate'
          get :usd_inr do
            begin
              response = HTTParty.get(
                'https://api.frankfurter.app/latest?from=USD&to=INR',
                timeout: 5
              )
              rate = response.parsed_response.dig('rates', 'INR')
              { rate: rate || 84.0 }
            rescue
              { rate: 84.0 }
            end
          end
        end
      end
    end
  end
end
