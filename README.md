# CTDownloadProgressButton

iCloud style button to display progress of a download and stop it.

## Screenshot
![Screenshot](https://github.com/ebf/CTDownloadProgressButton/raw/master/Screenshot/CTDownloadProgressButton.png)

## Usabe

```objc
// setup button
CTDownloadProgressButton *button = [[CTDownloadProgressButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 29.0f, 29.0f)];
[button addTarget:self action:@selector(_stopDownloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

// set progress
button.progress = 0.45f;
```

## License
MIT
