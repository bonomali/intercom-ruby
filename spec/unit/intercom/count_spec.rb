require "spec_helper"

describe "Intercom::Count" do
  let(:client) { Intercom::Client.new(token: 'token') }

  it 'should get app wide counts' do
    client.expects(:get).with("/counts", {}).returns(test_app_count)
    counts = client.counts.for_app
    _(counts.tag['count']).must_equal(341)
  end

  it 'should get type counts' do
    client.expects(:get).with("/counts", {type: 'user', count: 'segment'}).returns(test_segment_count)
    counts = client.counts.for_type(type: 'user', count: 'segment')
    _(counts.user['segment'][4]["segment 1"]).must_equal(1)
  end

  it 'should not include count param when nil' do
    client.expects(:get).with("/counts", {type: 'conversation'}).returns(test_conversation_count)
    counts = client.counts.for_type(type: 'conversation')
    _(counts.conversation).must_equal({
      "assigned" => 1,
      "closed" => 15,
      "open" => 1,
      "unassigned" => 0
    })
  end
end
