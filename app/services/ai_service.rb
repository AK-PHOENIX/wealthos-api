class AiService
  GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"

  def self.chat(user_message, context)
    prompt = <<~PROMPT
      You are WealthOS AI, a personal finance assistant for Indian investors.
      Here is the user's financial context:
      #{context}

      User question: #{user_message}

      Reply in 3-5 lines max. Be specific, use the numbers from context.
      Use ₹ for currency. Be helpful, calm, and direct.
    PROMPT

    response = HTTParty.post(
      "#{GEMINI_URL}?key=#{ENV['GEMINI_API_KEY']}",
      headers: { 'Content-Type' => 'application/json' },
      body: {
        contents: [{ parts: [{ text: prompt }] }]
      }.to_json
    )

    response.dig('candidates', 0, 'content', 'parts', 0, 'text') || 'Unable to process right now.'
  rescue => e
    "Sorry, AI service is temporarily unavailable."
  end

  def self.categorize_expense(description)
    prompt = "Categorize this expense into exactly one of: Food, Transport, EMI, Entertainment, Healthcare, Shopping, Other. Expense: '#{description}'. Reply with just the category word, nothing else."

    response = HTTParty.post(
      "#{GEMINI_URL}?key=#{ENV['GEMINI_API_KEY']}",
      headers: { 'Content-Type' => 'application/json' },
      body: {
        contents: [{ parts: [{ text: prompt }] }]
      }.to_json
    )

    response.dig('candidates', 0, 'content', 'parts', 0, 'text')&.strip || 'Other'
  rescue
    'Other'
  end
end
