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
 * A mechanism for downloading the images in questing and making them appear.

### Implementation

This code is all available on Github; clone it and follow along:

    ~/code$ git clone git://github.com/abscondment/lazy-gallery.git

 * [LazyGalleryAdapter](https://github.com/abscondment/lazy-gallery/blob/master/src/org/threebrothers/lazy_gallery/LazyGalleryAdapter.mirah)
   <br/>
   Android's list-like views are backed by an
   *[Adapter](http://developer.android.com/reference/android/widget/Adapter.html)*,
   which provides a standard interface for creating or updating Views to 
   represent list items. This subclass accepts a list of url/caption pairs and
   creates ImageViews for the gallery to display. It employs a common adapter
   optimization and re-uses a few existing views by updating them rather than
   repeatedly instantiating and discarding many views.
   <br/><br/>
 * [GallerySelectionListener](https://github.com/abscondment/lazy-gallery/blob/master/src/org/threebrothers/lazy_gallery/GallerySelectionListener.mirah)
   <br/>
   This listener handles selection changes. It figures out which views are
   visible when a selection is made and initiates loading of the associated
   images. By using `gallery.setCallbackDuringFling false` when creating the
   gallery, we disable the selection listener during flings so that it only
   gets called when we actually want to load images.
   <br/><br/>
 * [LazyImageView](https://github.com/abscondment/lazy-gallery/blob/master/src/org/threebrothers/lazy_gallery/LazyImageView.mirah)
   and [AsyncDownload](https://github.com/abscondment/lazy-gallery/blob/master/src/org/threebrothers/lazy_gallery/AsyncDownload.mirah)
   <br/>
   The LazyImageView is an ImageView with plumbing for loading a remote image
   asynchronously (i.e. off the UI thread). AsyncDownload uses some
   `java.util.concurrent` goodies to ensure that a given image is only
   transferred once (imagine the scenario where a user goes back and forth
   between two neighboring images before either loads &ndash; we don't want the
   two selection events to trigger double downloads of the images).
   LazyImageView also handles large images gracefully by asynchronously resizing
   them on disk; otherwise, we will get killed for using too much memory. It
   builds up a disk-based cache of downloaded images and has the ability to
   invalidate based on image age.
   <br/><br/>

Using these components together is fairly straightforward:

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
