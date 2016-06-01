---
date:  2004-01-22
title: Interesting method...
---
For those of you who (like me) are nerdy computer-types, here's an interesting bit of code I just wrote:

    /**
     * Convert given Binary Search Tree into an ordered linked list.
     * @param root the BinaryNode that is the root of the tree to order and link
     * @return the first Link in the ordered linked list
     * @author Brendan Ribera - January 2004
     */
    public Link linkUp(BinaryNode root) {
      // base case; node has no children
      //(list is Link of node alone)
      if (root.left == null &amp;&amp; root.right == null)
        return new Link(root.data);

      // node has two children
      else if (root.left != null &amp;&amp; root.right != null) {
        Link rightSide = linkUp(root.right);
        Link mid = new Link(root.data, rightSide);
        Link leftSide = linkUp(root.left);
        Link temp = leftSide;
        while (temp.next != null)
          temp = temp.next;
        temp.next = mid;
        return leftSide;

        // node has one child, right side
      } else if (root.right != null) {
        Link rightSide = linkUp(root.right);
        return new Link(root.data, rightSide);

        // node has one child, left side
      } else { // if (root.left != null)
        Link mid = new Link(root.data);
        Link leftSide = linkUp(root.left);
        Link temp = leftSide;
        while (temp.next != null)
          temp = temp.next;
        temp.next = mid;
        return leftSide;
      }
    }

It's a Java method that takes a given Binary Search Tree root and returns the first Link in a linked list representing all that tree's data, in order.

This method is cool conceptually, but due to it's recursive nature, it's a real memory hog and isn't very fast (look at the case where the Binary Node has two children--that case recursively calls <i>both</i> children; costly costly costly!).

Iterative would be a much better way to do it, but recursive things are just so <i>fun</i>!

