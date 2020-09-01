*This is part of a series on [Rails 2 Upgrade Turbulence](http://threebrothers.org/brendan/blog/rails2-upgrade-turbulence).*

Urbanspoon uses sessions to store various bits of information in the database that users might want to see again. We have a neat hack that Adam wrote to [turn off sessions for bots](http://gurge.com/blog/2007/01/08/turn-off-rails-sessions-for-robots/) so that we don't need to touch that table unless necessary.

Unfortunately, his trick depends on the Rails 1.x ability to toggle sessions progammatically. Rails 2 opted for lazy loading &ndash; if you don't access it, it never gets loaded. There is, in fact, no out-of-the-box way to disable the session progammatically at request time.

The trick I used to make this work is simple: choose the session store for a given request in a `before_filter`. I made a simple session that dumps all its data into a Hash, but never persists anything.

<noscript>
  <pre>
    <code>
# NoSession acts like a session, but doesn't get stored anywhere. Sneaky.
class NoSession < AbstractSession
  class << self
    def find_session(session_id); end
    def create_session(session_id, data={})
      new(session_id, data)
    end
    def delete_all(condition=nil); end
  end

  def update_session(data); end
  def destroy; end
end    
    </code>
  </pre>
</noscript>
<script src="//gist.github.com/653039.js?file=no_session.rb"></script>

I then created a subclass of our session store (SqlSessionStore, in our case) that has a class-level toggle ("disabled") which it uses to choose the backing session class when it is called.


<noscript>
  <pre>
    <code>
class OptionalSessionStore < SqlSessionStore

  cattr_accessor :enabled_session_class  
  cattr_accessor :disabled

  class << self
    def disabled=(v)
      if self.disabled != v
        @@disabled = v
        self.toggle_session_class
      end
    end

    def toggle_session_class
      if self.disabled
        SqlSessionStore.session_class = NoSession
      else
        SqlSessionStore.session_class = self.enabled_session_class
      end
    end  
  end
  
  def call(env)
    # Make sure our disabled state is current
    self.class.toggle_session_class
    super(env)
  end
end
    </code>
  </pre>
</noscript>
<script src="//gist.github.com/653053.js?file=optional_session_store.rb"></script>

I now use a before filter to enable or disable sessions even for code paths that attempt to access them.

<noscript>
  <pre>
    <code>
before_filter :toggle_session

def toggle_session    
  # Disable the session if we spy a bot (or it was disabled elsewhere), enable otherwise.
  if @disable_session.nil?
    @disable_session = UrbanspoonUtil.is_megatron?(request.user_agent)
  end
  OptionalSessionStore.disabled = @disable_session
end
    </code>
  </pre>
</noscript>
<script src="//gist.github.com/653049.js?file=toggle_session.rb"></script>
