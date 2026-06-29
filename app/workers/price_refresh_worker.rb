class PriceRefreshWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default

  def perform
    # Crypto
    response = HTTParty.get(
      "#{ENV['COINGECKO_API_URL']}/simple/price",
      query: {
        ids: 'bitcoin,ethereum,solana,binancecoin,cardano',
        vs_currencies: 'inr',
        include_24hr_change: true
      }
    )

    response.parsed_response.each do |coin_id, data|
      PriceCache.find_or_initialize_by(symbol: coin_id, asset_type: 'crypto')
                .update!(price: data['inr'], updated_at: Time.current)
    end

    Rails.logger.info "Prices refreshed at #{Time.current}"
  end
end
