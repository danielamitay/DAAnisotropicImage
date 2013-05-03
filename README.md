## DAAnisotropicImage

`DAAnisotropicImage` is an anisotropic `UIImage` generator. Specifically, for a metallic slider knob.

It was built to be an imitation of the volume slider thumb image in Apple's iOS 6.0 Music app.

View the included example project for a demonstration. It also demonstrates the CPU usage.

![Screenshot](https://github.com/danielamitay/DAAnisotropicImage/raw/master/screenshot.png)

## Discussion

On June 12, 2012, Gizmodo wrote an [article](http://gizmodo.com/5917967/you-wont-believe-how-insane-this-tiny-new-detail-in-ios-6-is) about an overlooked feature in the iOS 6.0 beta: a skeuomorphic metallic slider in the Music app.

You can see a YouTube video of the feature [here](http://www.youtube.com/watch?v=c9X7D87uJ7Q).

The change was criticized by some as a waste of resources and developer time. This project is a demonstration of how quickly the feature can be replicated, and how (relatively) CPU-light it is. Ultimately, this feature uses between 10% and 20% of the CPU (mainly for drawing). Compare that to simply sliding a `UISlider` at about half that amount. Note that this usage is only relative to the CPU allocated to the app. Play music in the background and the CPU usage will remain constant, for example.

## Installation

To use `DAAnisotropicImage`:

- Copy over the `DAAnisotropicImage` folder (and it's subfolder) to your project folder.
- Make sure that your project includes the `CoreMotion.framework`.
- Call `-startAnisotropicUpdatesWithHandler:` appropriately.

## Notes

### Automatic Reference Counting (ARC) support
`DAAnisotropicImage` was made with ARC enabled by default.

## Contact

- [Personal website](http://danielamitay.com)
- [GitHub](http://github.com/danielamitay)
- [Twitter](http://twitter.com/danielamitay)
- [LinkedIn](http://www.linkedin.com/in/danielamitay)
- [Email](mailto:hello@danielamitay.com)

If you use/enjoy `DAAnisotropicImage`, let me know!

## License

### MIT License

Copyright (c) 2013 Daniel Amitay (http://www.danielamitay.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
