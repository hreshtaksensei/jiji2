# coding: utf-8

require 'jiji/test/test_configuration'
require 'jiji/test/data_builder'

describe Jiji::Model::Trading::TickRepository do
  before(:context) do
    @data_builder = Jiji::Test::DataBuilder.new
    @repository = Jiji::Model::Trading::TickRepository.new
  end

  after(:context) do
    @data_builder.clean
  end

  context 'tickが登録されている場合' do
    before(:context) do
      @data_builder.register_ticks(11)
    end
    after(:context) do
      @data_builder.clean
    end

    it 'fetch で tickの一覧を取得できる' do
      ticks = @repository.fetch(Time.at(0), Time.at(100))

      expect(ticks.length).to eq(5)
      expect(ticks[0][:EURJPY].bid).to eq(100)
      expect(ticks[0][:EURJPY].ask).to eq(100.003)
      expect(ticks[0][:EURJPY].buy_swap).to eq(2)
      expect(ticks[0][:EURJPY].sell_swap).to eq(20)
      expect(ticks[0].timestamp).to eq(Time.at(0))

      expect(ticks[1][:EURJPY].bid).to eq(101)
      expect(ticks[1][:EURJPY].ask).to eq(101.003)
      expect(ticks[1][:EURJPY].buy_swap).to eq(3)
      expect(ticks[1][:EURJPY].sell_swap).to eq(21)
      expect(ticks[1].timestamp).to eq(Time.at(20))

      expect(ticks[4][:EURJPY].bid).to eq(104)
      expect(ticks[4][:EURJPY].ask).to eq(104.003)
      expect(ticks[4][:EURJPY].buy_swap).to eq(6)
      expect(ticks[4][:EURJPY].sell_swap).to eq(24)
      expect(ticks[4].timestamp).to eq(Time.at(80))

      expect(ticks[0][:USDJPY].bid).to eq(100)
      expect(ticks[0][:USDJPY].ask).to eq(100.003)
      expect(ticks[0][:USDJPY].buy_swap).to eq(2)
      expect(ticks[0][:USDJPY].sell_swap).to eq(20)
      expect(ticks[0].timestamp).to eq(Time.at(0))

      expect(ticks[1][:USDJPY].bid).to eq(101)
      expect(ticks[1][:USDJPY].ask).to eq(101.003)
      expect(ticks[1][:USDJPY].buy_swap).to eq(3)
      expect(ticks[1][:USDJPY].sell_swap).to eq(21)
      expect(ticks[1].timestamp).to eq(Time.at(20))

      expect(ticks[4][:USDJPY].bid).to eq(104)
      expect(ticks[4][:USDJPY].ask).to eq(104.003)
      expect(ticks[4][:USDJPY].buy_swap).to eq(6)
      expect(ticks[4][:USDJPY].sell_swap).to eq(24)
      expect(ticks[4].timestamp).to eq(Time.at(80))

      ticks = @repository.fetch(Time.at(30), Time.at(110))

      expect(ticks.length).to eq(4)
      expect(ticks[0][:EURJPY].bid).to eq(102)
      expect(ticks[0][:EURJPY].ask).to eq(102.003)
      expect(ticks[0][:EURJPY].buy_swap).to eq(4)
      expect(ticks[0][:EURJPY].sell_swap).to eq(22)
      expect(ticks[0].timestamp).to eq(Time.at(40))

      expect(ticks[3][:EURJPY].bid).to eq(105)
      expect(ticks[3][:EURJPY].ask).to eq(105.003)
      expect(ticks[3][:EURJPY].buy_swap).to eq(7)
      expect(ticks[3][:EURJPY].sell_swap).to eq(25)
      expect(ticks[3].timestamp).to eq(Time.at(100))

      ticks = @repository.fetch(Time.at(150), Time.at(300))

      expect(ticks.length).to eq(3)
      expect(ticks[0][:EURJPY].bid).to eq(108)
      expect(ticks[0][:EURJPY].ask).to eq(108.003)
      expect(ticks[0][:EURJPY].buy_swap).to eq(10)
      expect(ticks[0][:EURJPY].sell_swap).to eq(28)
      expect(ticks[0].timestamp).to eq(Time.at(160))

      expect(ticks[2][:EURJPY].bid).to eq(100)
      expect(ticks[2][:EURJPY].ask).to eq(100.003)
      expect(ticks[2][:EURJPY].buy_swap).to eq(2)
      expect(ticks[2][:EURJPY].sell_swap).to eq(20)
      expect(ticks[2].timestamp).to eq(Time.at(200))
    end

    it 'range で tickが登録されている期間を取得できる' do
      range = @repository.range

      expect(range[:start]).to eq(Time.at(0))
      expect(range[:end]).to eq(Time.at(200))
    end
  end

  context 'tickが1つだけ登録されている場合' do
    before(:context) do
      @data_builder.register_ticks(1)
    end
    after(:context) do
      @data_builder.clean
    end

    it 'fetch で tickの一覧を取得できる' do
      ticks = @repository.fetch(Time.at(0), Time.at(100))

      expect(ticks.length).to eq(1)
      expect(ticks[0][:EURJPY].bid).to eq(100)
      expect(ticks[0][:EURJPY].ask).to eq(100.003)
      expect(ticks[0][:EURJPY].buy_swap).to eq(2)
      expect(ticks[0][:EURJPY].sell_swap).to eq(20)
      expect(ticks[0].timestamp).to eq(Time.at(0))
    end

    it 'range で tickが登録されている期間を取得できる' do
      range = @repository.range

      expect(range[:start]).to eq(Time.at(0))
      expect(range[:end]).to eq(Time.at(0))
    end
  end

  context 'tickが1つも登録されていない場合' do
    after(:context) do
      @data_builder.clean
    end

    it 'fetch で tickの一覧を取得できる' do
      expect do
        @repository.fetch(Time.at(0), Time.at(100))
      end.to raise_error(ArgumentError)
    end

    it 'range で tickが登録されている期間を取得できる' do
      range = @repository.range

      expect(range[:start]).to be_nil
      expect(range[:end]).to be_nil
    end
  end

  it 'delete で tick を削除できる' do
    @data_builder.register_ticks(11)
    expect(Jiji::Model::Trading::Tick.count).to eq(11)
    range = @repository.range
    expect(range[:start]).to eq(Time.at(0))
    expect(range[:end]).to eq(Time.at(200))

    @repository.delete(Time.at(-50), Time.at(50))
    expect(Jiji::Model::Trading::Tick.count).to eq(8)
    range = @repository.range
    expect(range[:start]).to eq(Time.at(60))
    expect(range[:end]).to eq(Time.at(200))

    @repository.delete(Time.at(100), Time.at(160))
    expect(Jiji::Model::Trading::Tick.count).to eq(5)
    range = @repository.range
    expect(range[:start]).to eq(Time.at(60))
    expect(range[:end]).to eq(Time.at(200))

    @repository.delete(Time.at(160), Time.at(260))
    expect(Jiji::Model::Trading::Tick.count).to eq(2)
    range = @repository.range
    expect(range[:start]).to eq(Time.at(60))
    expect(range[:end]).to eq(Time.at(80))

    @repository.delete(Time.at(180), Time.at(260))
    expect(Jiji::Model::Trading::Tick.count).to eq(2)
    range = @repository.range
    expect(range[:start]).to eq(Time.at(60))
    expect(range[:end]).to eq(Time.at(80))

    @data_builder.clean
  end
end