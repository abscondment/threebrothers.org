## Image Galleries

The Gallery is a horizontal scrolling list commonly used for displaying a list
of images. Unfortunately, the standard Android Developers
[Gallery tutorial](http://developer.android.com/resources/tutorials/views/hello-gallery.html)
focuses on displaying a small, static list of local images. An API-based list
of remote images is much more useful, but more complex.

### Laziness

Needing to fetch remote images is the cause of this complexity. A naïve approach
might download all of the images sequentially, but that quickly becomes
untenable as the number of images in question grows.

The correct solution will build up a cache of images locally, fetching them only
as they need to be displayed. Images that have not yet loaded will be
represented by a placeholder.

### Mirah

I've grown quite fond of Mirah since I wrote my
[initial reactions about Mirah-Android development](../experimenting-with-mirah-for-android).
Despite the bleeding edge kinks and snares, I find myself being *much* more
productive than when using vanilla Java. Since the language is relatively new,
I thought it could be useful to walk through some real-world code and
demonstrate what it can do.

## Designing a Lazy Gallery

We'll make three components:

 * An adapter to provide image/view information.
 * A selection listener to load images when they enter the visible window.
 * A mechanism for downloading the images in question and making them appear.

### Implementation

This code is all available on Github; clone it and follow along:

    git clone git://github.com/abscondment/lazy-gallery.git

#### LazyGalleryAdapter.mirah

Android's list-like views are backed by an
*[Adapter](http://developer.android.com/reference/android/widget/Adapter.html)*,
which provides a standard interface for creating or updating Views to 
represent list items.

This implementation accepts a JSON string and turns it into equivalent Java
objects.

<script src="https://gist.github.com/898441.js?file=update_from_json.mirah"></script>
<noscript>
<pre>
  <code>
def update_from_json(json:String)
  begin
    data = JSONArray.new json
    data.length.times do |i|
      photo_json = data.getJSONObject(i)
      @photos.add {'caption' => photo_json.getString('caption'), 'src' => photo_json.getString('src')}
    end
  rescue JSONException => e
    Log.e 'LazyGalleryAdapter', 'Could not load JSON', e
  end
  notifyDataSetChanged()
end
  </code>
</pre>
</noscript>

Using this list of caption/src pairs, it creates ImageViews for the gallery to
display. It employs a common adapter optimization and re-uses a few existing
views by updating them rather than repeatedly instantiating and discarding 
many objects.

<script src="https://gist.github.com/898446.js?file=getView.mirah"></script>
<noscript>
<pre>
  <code>
def getView(pos:int, convertView:View, parent:ViewGroup)
  layout = RelativeLayout(convertView)
  image = LazyImageView(nil)
  url = String(Map(getItem pos).get('src'))

  if layout.nil?
    image = LazyImageView.new(@context, R.drawable.placeholder)
    image.setScaleType(ImageView.ScaleType.FIT_XY)
    image.setLayoutParams Gallery.LayoutParams.new(@oneeighty,@oneeighty)
    image.setBackgroundResource(R.drawable.gallery_background)
    image.setOnClickListener nil
    image.setClickable false

    layout = RelativeLayout.new @context
    layout.setLayoutParams Gallery.LayoutParams.new(@oneeighty,@oneeighty)
    layout.setGravity Gravity.CENTER
    layout.addView image
  else
    image = LazyImageView(layout.getChildAt 0)
  end

  # show changes
  image.setSrcUrl url
  image.refresh

  return View(layout)
end
  </code>
</pre>
</noscript>

Note that we're not using a standard ImageView &ndash; it has extra methods
(e.g. `refresh`), which we'll talk about below.

While I chose to build the layout by hand to demonstrate more, we could have
eliminated some of the creation lines by inflating an XML resource:

<script src="https://gist.github.com/898447.js?file=inflate.mirah"></script>
<noscript>
<pre>
  <code>
if layout.nil?
  [...]
  inflater = LayoutInflater.from @context
  layout = inflater.inflate(R.layout.lazy_gallery_item, parent, false)
  layout.addView image
end
  </code>
</pre>
</noscript>
   
#### GallerySelectionListener.mirah

This listener handles selection changes. It figures out which views are
visible when a selection is made and initiates loading of the associated
images. By using `gallery.setCallbackDuringFling false` when creating the
gallery, we disable the selection listener during flings so that it only
gets called when we actually want to load images.

<script src="https://gist.github.com/898449.js?file=onItemSelected.mirah"></script>
<noscript>
<pre>
  <code>
def onItemSelected(parent:AdapterView, view:View, pos:int, id:long)
  unless @textView.nil?
    photo_map = Map(LazyGalleryAdapter(parent.getAdapter).getItem pos)
    if photo_map.containsKey('caption')
      @textView.setText String(photo_map.get('caption'))
      @textView.setVisibility View.VISIBLE
    else
      @textView.setVisibility View.INVISIBLE
    end
  end

  view.setSelected true

  # Preload children of the Gallery (i.e. those elements that are visible)
  unless parent.nil?
    parent.getChildCount.times do |i|
      v = RelativeLayout(parent.getChildAt(i))
      LazyImageView(v.getChildAt 0).load unless v.nil?
    end
  end
end
  </code>
</pre>
</noscript>

So, we use the LazyGalleryAdapter to get the caption/src map for our given
position. We update the caption and show it.

Then we iterate over the parent's children &ndash; these are the *visible*
children, mind you &ndash; and call `load` on the LazyImageViews that they
house.

#### LazyImageView.mirah

The LazyImageView is an [ImageView](http://developer.android.com/reference/android/widget/ImageView.html)
with plumbing for loading a remote image asynchronously (i.e. off the UI
thread). It attempts to display an image that is already on disk, but defers
fetching remote images until its `load` method is called.

<script src="https://gist.github.com/898450.js?file=image_display.mirah"></script>
<noscript>
<pre>
  <code>
def setSrcUrl(url:String):void
  @src_url = url
  @path = File.new(cache_dir, "" + @src_url.hashCode + ".jpg").getCanonicalPath
end
  
def load:void
  unless @loaded || @src_url.nil? || @path.nil?
    AsyncDownload.new(Handler.new(self), @src_url, @path)
  end
end
  
def refresh:void
  unless display_from_path()
    setImageResource @placeholder
  end
end

protected
  
def display_from_path
  d = safe_image_to_drawable(@path, 180)

  unless d.nil?
    setImageDrawable(d)
    @loaded = true
  else
    @resizing = false
    @loaded = false
  end
  return @loaded
end
  </code>
</pre>
</noscript>

LazyImageView also handles large images gracefully by asynchronously resizing
them on disk with [safe\_image\_to_drawable](https://github.com/abscondment/lazy-gallery/blob/master/src/org/threebrothers/lazy_gallery/LazyImageView.mirah#L137)
and AsyncResize; otherwise, we will get killed for using too much memory.

Finally, it can invalidate the disk-based cache of images based on image age.

<script src="https://gist.github.com/898451.js?file=purgeDiskCache.mirah"></script>
<noscript>
<pre>
  <code>
def self.cache_dir(c:Context):File
  @cache_dir ||= File.new(c.getCacheDir, "lazy_image_cache")
  @cache_dir.mkdirs unless @cache_dir.exists
  @cache_dir
end

def self.purgeDiskCache(c:Context):void
  thread = Thread.new do
    # 8 hours
    oldest_acceptable = System.currentTimeMillis - long(28800000)
    d = LazyImageView.cache_dir(c)

    files = d.listFiles unless d.nil?
    unless files.nil?
      files.each do |f|
        begin
          # Skip nils, directories, and current files.
          next if f.nil? || (!f.isFile) || f.lastModified >= oldest_acceptable
          Log.v "LazyImageView", "D " + f.getCanonicalPath
          f.delete
        rescue IOException => e
          Log.e "LazyImageView", "purgeDiskCache: Error checking or deleting cache file:", e
        end
      end
    end
  end
  
  # Do this on a different thread
  LazyGalleryActivity.threadPoolExecutor.execute thread
end
  </code>
</pre>
</noscript>

##### AsyncDownload.mirah

AsyncDownload is a fun little helper for downloading basically anything. It uses
some `java.util.concurrent` goodies to ensure that a given URL is only fetched
once for a destination path. Imagine the scenario where a user goes back and
forth between two neighboring images before either loads &ndash; we don't want
the two selection events to trigger double downloads of the images.

I won't post source here, but [it's worth a read](https://github.com/abscondment/lazy-gallery/blob/master/src/org/threebrothers/lazy_gallery/AsyncDownload.mirah).

## Working Together

Using these components is fairly straightforward:

<script src="https://gist.github.com/897860.js?file=gistfile1.rb"></script>
<noscript>
  <pre>
    <code>
gallery = Gallery(findViewById R.id.lazy_gallery)
# Make sure the GallerySelectionListener is only
# triggered when the gallery is stopped on an image.
gallery.setCallbackDuringFling false

# Create our adapter
gallery_adapter = LazyGalleryAdapter.new self

# When the current item is clicked, create a toast with its caption.
this = self
gallery.setOnItemClickListener do |parent, view, pos, id|
  if view.isSelected
    item = Map(gallery_adapter.getItem pos)
    c = String(item.get 'caption') || "Item #{pos} (no caption)"
    Toast.makeText(this, c, Toast.LENGTH_SHORT).show
  end
end

# Add the adapter and the selection listener
gallery.setAdapter gallery_adapter    
gallery.setOnItemSelectedListener GallerySelectionListener.new(TextView(findViewById R.id.lazy_gallery_text))

# Expire any old cached images
LazyImageView.purgeDiskCache(self)

# And finally, send the adapter its data.
# A real application will likely abstract away the JSON string details.
gallery_adapter.update_from_json json_string
    </code>
  </pre>
</noscript>

## Try it out

The full source is available on Github as a working application. Try it out!

[https://github.com/abscondment/lazy-gallery](https://github.com/abscondment/lazy-gallery)
