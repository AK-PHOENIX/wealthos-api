module API
  module V1
    module Market
      class Markets < Grape::API

        resource :markets do

          desc 'Get crypto prices'
          get :crypto do
            cached = PriceCache.where(asset_type: 'crypto')
                               .where('updated_at > ?', 15.minutes.ago)
            return cached if cached.exists?

            response = HTTParty.get(
              "#{ENV['COINGECKO_API_URL']}/simple/price",
              query: {
                ids: 'bitcoin,ethereum,solana,binancecoin,cardano',
                vs_currencies: 'inr',
                include_24hr_change: true
              }
            )

            response.parsed_response.map do |coin_id, data|
              PriceCache.find_or_initialize_by(symbol: coin_id, asset_type: 'crypto')
                        .update(price: data['inr'], updated_at: Time.current)
            end

            PriceCache.where(asset_type: 'crypto')
          end

          desc 'Get stock prices'
          get :stocks do
            # Alpha Vantage or mock data
            # Add real integration same pattern as crypto above
            PriceCache.where(asset_type: 'stock')
          end

        end
      end
    end
  end
end
