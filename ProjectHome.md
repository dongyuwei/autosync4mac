auto sync local files to remote server , for mac users. based on fsevent.

> 之所以写这个脚本，是想在修改本地文件后立马推到测试服务器上，并且保持文件系统的结构不变（嵌套文件夹结构不变）。另外一个原因是aptana IDE中sftp插件在mac下会经常丢失同步连接,让鄙人忍无可忍。

文件的修改是监听mac fsevent系统（linux下有inotify系统）提供的事件，使用scp（想简单也可以考虑通过HTTP）同步到服务器，使用growl桌面消息通知系统反馈同步结果。

需要先设置growl监听网络连接，因为ruby-growl库是通过udp发提醒消息的。最后一点，需要给脚本合适的运行权限。

文件过滤了.svn,.hg,.git版本文件。

fsevent事件触发和响应很快，不过ruby scp上传文件会比较慢（2011年2月9日修改为复用连接，性能明显提高）。

linux版本暂未提供，有兴趣的应该可以很快搞定。

已知bug：ruby fsevents无法捕获文件系统重命名事件。
todo：支持多目录同步

All I need is just  **rsync**, sigh!