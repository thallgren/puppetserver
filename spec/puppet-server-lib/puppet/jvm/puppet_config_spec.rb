require 'puppet/server/puppet_config'

describe 'Puppet::Server::PuppetConfig' do
  context "When puppet has had settings initialized" do
    before :each do
      mock_puppet_config = {}
      Puppet::Server::PuppetConfig.initialize_puppet(mock_puppet_config)
    end

    describe "the puppet log level (Puppet[:log_level])" do
      subject { Puppet[:log_level] }
      it 'is set to debug (the highest) so messages make it to logback' do
        expect(subject).to eq('debug')
      end
    end

    describe "the puppet log level (Puppet::Util::Log.level)" do
      subject { Puppet::Util::Log.level }
      it 'is set to debug (the highest) so messages make it to logback' do
        expect(subject).to eq(:debug)
      end
    end

    describe '(PUP-5482) Puppet[:always_retry_plugins]' do
      subject { Puppet[:always_retry_plugins] }
      it 'is false for increased performance in puppetserver' do
        expect(subject).to eq(false)
      end
    end

    describe '(PUP-6060) Puppet::Node indirection caching' do
      subject { Puppet[:node_cache_terminus] }
      it 'is nil to avoid superfluous caching' do
        expect(subject).to be_nil
      end

      subject { Puppet::Node.indirection.cache_class }
      it 'is nil to avoid superfluous caching'do
        expect(subject).to be_nil
      end
    end
  end

  # Even though we don't set the node_cache_terminus setting value, so it
  # defaults to nil, we want to honor it if users have specified it directly.
  # PUP-6060 / SERVER-1819
  subject { Puppet::Node.indirection.cache_class }
  it 'honors the Puppet[:node_cache_terminus] setting' do
    Puppet::Server::PuppetConfig.initialize_puppet({ :node_cache_terminus => "plain" })
    expect(subject).to eq(:plain)
  end
end
