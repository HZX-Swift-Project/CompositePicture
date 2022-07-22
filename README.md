# CompositePicture
编辑并合成图片
### 最终效果图
<table>
    <tr>
        <td ><center><img src="https://img-blog.csdnimg.cn/5f940f3c4f974bfc988d698097eb7724.gif#pic_center"><br/>普通封面图</center></td>
        <td ><center><img src="https://img-blog.csdnimg.cn/a4466e643d1e4e9b9838865d46b409d1.gif#pic_center"><br/>图片贴纸</center></td>
        <td ><center><img src="https://img-blog.csdnimg.cn/96d00f1d35da4487b11bf7798c8ebc49.gif#pic_center"><br/>文字贴纸</center></td>
    </tr>
</table>

### 核心代码
**镜像**
```swift
/// 编辑图片
/// - Parameters:
///   - radians: 旋转的弧度
///   - isMirrorH: 是否水平镜像
///   - isMirrorV: 是否垂直镜像
/// - Returns: 编辑后的图片
func operate(radians: CGFloat = 0.0, isMirrorH: Bool = false, isMirrorV: Bool = false) -> UIImage {
	if radians == 0.0, !isMirrorH, !isMirrorV {
	    return self
	}
	var targetImage = self
	if isMirrorH {
	    // 水平镜像
	    targetImage = targetImage.flipH()
	}
	if isMirrorV {
	    // 垂直镜像
	    targetImage = targetImage.flipV()
	}
	return targetImage.rotate(radians: radians)
}

/// 旋转图片
/// - Parameter radians: 旋转弧度数
/// - Returns: 编辑后的图片
func rotate(radians: CGFloat = 0.0) -> UIImage {
	if radians == 0.0 {
	    return self
	}
	let imageRect = CGRect(origin: .zero, size: size)
	// 获取旋转后的图片尺寸大小
	var rotatedRect = imageRect.applying(CGAffineTransform(rotationAngle: CGFloat(radians))).integral
	rotatedRect.origin.x = 0
	rotatedRect.origin.y = 0
	// 开启画布 这里第三个参数 scale 出入0 系统会自动缩放
	UIGraphicsBeginImageContextWithOptions(rotatedRect.size, false, 0.0)
	guard let context = UIGraphicsGetCurrentContext() else { return self }
	// 把旋转点放在屏幕中心
	context.translateBy(x: rotatedRect.width / 2, y: rotatedRect.height / 2)
	context.rotate(by: radians)
	context.translateBy(x: -size.width / 2, y: -size.height / 2)
	// 开始绘画
	draw(at: .zero)
	// 获取图片
	let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	return rotatedImage ?? self
}

///  水平镜像
/// - Returns: 处理过后的图片
func flipH() -> UIImage {
	return self.withHorizontallyFlippedOrientation()
}

/// 垂直镜像
/// - Returns: 处理过后的图片
func flipV() -> UIImage {
	// 先绕中心点旋转180度 然后再水平镜像
	return self.rotate(radians: CGFloat(Double.pi)).withHorizontallyFlippedOrientation()
}
```
#### 图片合成
**1.计算视图位置**
利用 `convert(_ rect: CGRect, to view: UIView?) -> CGRect` 函数，计算出目标视图相对于待切割区域的位置
```swift
// 获取封面图相对于图纸文件的位置
let rect = self.editContainerView.convert(coverView.frame, to: self.dashCutView)
```
**2.计算旋转角度**
利用 `atan2f(Float(view.transform.b), Float(view.transform.a))`计算出视图当前位置的旋转角度，这里计算的是 `-pi~pi` 弧度数，顺时针是正数，逆时针是负数
```swift
// 这是图片旋转的角度 弧度数 
let degree = atan2f(Float(coverView.transform.b), Float(coverView.transform.a))
```
**3.合成图片**

 1. 第一步：开启画布
 2. 第二步：绘制封面图
 3. 第三步：循环出编辑区域内所有的图片贴图和文字贴图，绘制贴图
 4. 第四步：关闭画布

```swift
var kScale = 4.0
if DD_ScreenWidth <= 375.0 {
    kScale = 5.0
}
// 获取封面背景图
guard let coverImage = coverView.image else { return DDMBProgressHUD.showTipMessage("未获取到图片信息") }
/// 开启上下文
let fileSize = self.dashCutView.DD_size;
let targetSize = CGSize(width: fileSize.width*kScale, height: fileSize.height*kScale);
// 开启画布
UIGraphicsBeginImageContextWithOptions(targetSize, false, 0);
// 获取封面图相对于图纸文件的位置
let rect = self.editContainerView.convert(coverView.frame, to: self.dashCutView)
// 绘制封面图
// 这是图片旋转的角度 弧度数
let degree = atan2f(Float(coverView.transform.b), Float(coverView.transform.a))
// 获取切割的位置
let targetRect = CGRect(x: rect.origin.x*kScale, y: rect.origin.y*kScale, width: rect.size.width*kScale, height: rect.size.height*kScale)
let coverRotateImage = coverImage.operate(radians: CGFloat(degree), isMirrorH: coverView.isMirrorH, isMirrorV: coverView.isMirrorV)
coverRotateImage.draw(in: targetRect)

	// 绘制贴图和文字
for view in editContainerView.subviews {
    if view !== coverView {
	if view is DDBaseEditView {
	    let editView = view as! DDBaseEditView
	    // 获取贴图
	    if let tagImage = editView.image {
		let degree = atan2f(Float(editView.transform.b), Float(editView.transform.a))
		var targetRect: CGRect = .zero
		if editView.isTextView {
		    let editViewRect = self.editContainerView.layer.convert(editView.layer.frame, to: self.dashCutView.layer)
		    targetRect = CGRect(x: editViewRect.origin.x*kScale, y: editViewRect.origin.y*kScale, width: editViewRect.size.width*kScale, height: editViewRect.size.height*kScale)
		} else {
		    let editViewRect = self.editContainerView.convert(editView.frame, to: self.dashCutView)
		    targetRect = CGRect(x: editViewRect.origin.x*kScale, y: editViewRect.origin.y*kScale, width: editViewRect.size.width*kScale, height: editViewRect.size.height*kScale)
		}
		let tagRotateImage = tagImage.operate(radians: CGFloat(degree), isMirrorH: editView.isMirrorH, isMirrorV: editView.isMirrorV)
		tagRotateImage.draw(in: targetRect)
	    }
	}
    }
}

let resultImage = UIGraphicsGetImageFromCurrentImageContext()
/// 关闭画布
UIGraphicsEndImageContext();
```
**`特别提醒`**
旋转会影响视图的尺寸，但是layer层的尺寸是不会更改的，这点很重要，由于绘制文字视图的时候，我这边首先把文字绘制成了图片，然后再与图片贴纸一起绘制成图片，所以我这里使用的是layer的尺寸。可以在`DDBaseView`的`image`属性查看。
