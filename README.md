# XJRefresh
using
table.addHeaderRefresh {
self.perform(#selector(self.stopRefresh), with: self, afterDelay: 2)
}
func stopRefresh() {
table.refreshHeader?.endRefresh()
}
