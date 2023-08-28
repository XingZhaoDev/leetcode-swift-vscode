/*
Let the depth of a UIView be the number of references to traverse before reaching some root UIView:
    Root
    /
   /
  ViewA
-> Depth of ViewA is 1 
Given a root UIView, and a target UIView, find all UIViews at the same depth as the target
Explanation
Let's consider we've a root UIView A and a target UIView C as structured below -

        A           <- Depth 1
      B   C         <- Depth 2
    D   E   F       <- Depth 3
So, here the depth of target view C is 2. Now, we've to find the views which at the same depth as view C. So, here we've another view B which depth is also 2.
*/

class TreeNode {
    var val: Int
    var left: TreeNode?
    var right: TreeNode?

    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }

    public init() {
        self.val = 0
        self.left = nil
        self.right = nil
    }

    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

