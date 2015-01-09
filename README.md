# Doppelganger

[![CI Status](https://travis-ci.org/Wondermall/Doppelganger.svg)](https://travis-ci.org/Wondermall/Doppelganger)
[![Version](https://img.shields.io/cocoapods/v/Doppelganger.svg?style=flat)](http://cocoadocs.org/docsets/Doppelganger)
[![License](https://img.shields.io/cocoapods/l/Doppelganger.svg?style=flat)](http://cocoadocs.org/docsets/Doppelganger)
[![Platform](https://img.shields.io/cocoapods/p/Doppelganger.svg?style=flat)](http://cocoadocs.org/docsets/Doppelganger)

# TL;DR;

<table>
<tr>
    <td>
        <img src="https://raw.githubusercontent.com/Wondermall/Doppelganger/master/Screenshot_bad.gif" alt="bad ux" style="max-width:100%;" width="186px">
    </td>
    <td>
        <img src="https://raw.githubusercontent.com/Wondermall/Doppelganger/master/Screenshot.gif" alt="good ux" style="max-width:100%;" width="186px">
    </td>
</tr>
<tr>
    <td>
        Bad UX
    </td>
    <td>
        Good UX<sup>1</sup>
    </td>
</tr>
</table>

<sup>1</sup>: Good UX slowed down intentionally to demonstrate the awesomeness

## Problems it solves

* Calculating mutations is too hard and you're just calling `reloadData` on your collection or table view? 
* Users, confused where did that row disappear?
* Rows, jumping out of nowhere?
* Lost scroll position?

Doppelganger is here to help!

## Usage

```objectivec
NSArray *oldDataSource = self.dataSource;
self.dataSource = [self _updatedDataSource];
NSArray *diffs = [WMLArrayDiffUtility diffForCurrentArray:self.dataSource
                                            previousArray:oldDataSource];

[self.tableView beginUpdates];
for (WMLArrayDiff *diff in diffs) {
    switch (diff.type) {
        case WMLArrayDiffTypeMove: {
            [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:diff.previousIndex inSection:0]
                                   toIndexPath:[NSIndexPath indexPathForRow:diff.currentIndex inSection:0]];
            break;
        }
        case WMLArrayDiffTypeDelete: {
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:diff.previousIndex inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationRight];
            break;
        }
        case  WMLArrayDiffTypeInsert: {
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:diff.currentIndex inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
    }
}
[self.tableView endUpdates];
```

## Implementation details

* Currently, doppelganger supports only array of unique elements, e.g. if you have duplicated elements in your array, result is unpredictable.
* If you are using custom classes, make sure that it implements correctly `isEqual:` and `hash` methods: [http://nshipster.com/equality/](http://nshipster.com/equality/)
* Sections are not hanlded intentionally. From our experince sections are harder to match using strict equality + hashing. However, if this is your case, feel free to use Doppelganger for setions, too.

## TODOs

* Improve on O(n<sup>2</sup>) when calculating moved elements.
* Abstract API from `NSArray`.
* Your issue / pull request.

## Installation

Doppelganger is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "Doppelganger"

## Author

Sash Zats, sash@zats.io

## License

Doppelganger is available under the MIT license. See the LICENSE file for more info.

