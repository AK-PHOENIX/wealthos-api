# Seed data for WealthOS

puts "Deleting existing data..."
PriceCache.delete_all
Transaction.delete_all
Holding.delete_all
Portfolio.delete_all
BudgetGoal.delete_all
Expense.delete_all
User.delete_all

puts "Creating default user Arjun Mehta..."
user = User.create!(
  name: "Arjun Mehta",
  email: "arjun@wealthos.app",
  monthly_income: 185000,
  currency: "INR",
  password: "password",
  password_confirmation: "password"
)

puts "Creating portfolios..."
portfolio = user.portfolios.create!(name: "Main Portfolio")

puts "Creating holdings and transactions..."
holdings_data = [
  { symbol: "BTC", asset_type: "crypto", quantity: 0.15, buy_price: 2450000, buy_date: "2024-02-15", current_price: 3015000 },
  { symbol: "ETH", asset_type: "crypto", quantity: 2.5, buy_price: 185000, buy_date: "2024-04-10", current_price: 218400 },
  { symbol: "SOL", asset_type: "crypto", quantity: 18.0, buy_price: 12500, buy_date: "2024-05-22", current_price: 14820 },
  { symbol: "RELIANCE", asset_type: "stock", quantity: 25.0, buy_price: 2680, buy_date: "2023-11-08", current_price: 2945 },
  { symbol: "INFY", asset_type: "stock", quantity: 40.0, buy_price: 1490, buy_date: "2024-01-20", current_price: 1572 },
  { symbol: "HDFCBANK", asset_type: "stock", quantity: 30.0, buy_price: 1610, buy_date: "2024-03-05", current_price: 1684 },
  { symbol: "TCS", asset_type: "stock", quantity: 12.0, buy_price: 3850, buy_date: "2024-02-28", current_price: 4120 },
  { symbol: "MIRAE-LC", asset_type: "mutual_fund", quantity: 1250.0, buy_price: 92.4, buy_date: "2023-09-12", current_price: 104.8 }
]

holdings_data.each do |h|
  holding = portfolio.holdings.create!(
    symbol: h[:symbol],
    asset_type: h[:asset_type],
    quantity: h[:quantity],
    buy_price: h[:buy_price],
    buy_date: Date.parse(h[:buy_date])
  )

  # Create a corresponding transaction
  holding.transactions.create!(
    transaction_type: "buy",
    quantity: h[:quantity],
    price: h[:buy_price],
    transaction_date: Date.parse(h[:buy_date])
  )

  # Populate price cache
  PriceCache.create!(
    symbol: h[:symbol],
    asset_type: h[:asset_type],
    price: h[:current_price]
  )
end

puts "Creating budget goals..."
budgets_data = [
  { category: "Food", monthly_limit: 8000 },
  { category: "Transport", monthly_limit: 5000 },
  { category: "EMI", monthly_limit: 35000 },
  { category: "Entertainment", monthly_limit: 3000 },
  { category: "Healthcare", monthly_limit: 4000 },
  { category: "Shopping", monthly_limit: 10000 }
]

budgets_data.each do |b|
  user.budget_goals.create!(
    category: b[:category],
    monthly_limit: b[:monthly_limit],
    month: Date.today.month,
    year: Date.today.year
  )
end

puts "Creating expenses..."
expenses_data = [
  { amount: 480, description: "Swiggy dinner", category: "Food", days_ago: 0 },
  { amount: 220, description: "Uber to office", category: "Transport", days_ago: 0 },
  { amount: 1599, description: "Netflix annual", category: "Entertainment", days_ago: 1 },
  { amount: 35000, description: "Home loan EMI", category: "EMI", days_ago: 2 },
  { amount: 2400, description: "Apollo pharmacy", category: "Healthcare", days_ago: 3 },
  { amount: 4250, description: "Myntra shopping", category: "Shopping", days_ago: 4 },
  { amount: 850, description: "Zomato lunch", category: "Food", days_ago: 5 },
  { amount: 3200, description: "Petrol", category: "Transport", days_ago: 7 },
  { amount: 1200, description: "Spotify family", category: "Entertainment", days_ago: 9 },
  { amount: 5800, description: "Amazon Echo", category: "Shopping", days_ago: 12 },
  { amount: 650, description: "Cafe Coffee Day", category: "Food", days_ago: 14 },
  { amount: 12500, description: "Car insurance", category: "Other", days_ago: 18 },
  { amount: 1850, description: "Concert tickets", category: "Entertainment", days_ago: 21 },
  { amount: 720, description: "Ola airport", category: "Transport", days_ago: 24 },
  { amount: 3400, description: "Dentist visit", category: "Healthcare", days_ago: 28 }
]

expenses_data.each do |e|
  user.expenses.create!(
    amount: e[:amount],
    description: e[:description],
    category: e[:category],
    expense_date: Date.today - e[:days_ago],
    ai_categorized: false
  )
end

puts "Done seeding!"
