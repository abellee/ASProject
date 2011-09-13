package {
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import fl.controls.dataGridClasses.HeaderRenderer;

	import flash.display.Sprite;

	/**
	 * @author Abel Lee
	 */
	public class DataGridColumnRenderer extends HeaderRenderer {
		public function DataGridColumnRenderer() {
			super();
		}

		override protected function drawBackground():void
		{
			var bk:Sprite = new Sprite();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(this.width, this.height, Math.PI / 2, 0, 0);
			bk.graphics.lineStyle(.5, 0xadc0d4);
			bk.graphics.beginGradientFill(GradientType.LINEAR, [0xfafbfd, 0xe8f0f7], [1.0, 1.0], [0, 255], matrix);
			bk.graphics.drawRect(0, 0, this.width, this.height);
			bk.graphics.endFill();
			setStyle("upSkin", bk);
			setStyle("downSkin", bk);
			setStyle("overSkin", bk);
			setStyle("disabledSkin", bk);
			super.drawBackground();
		}
	}
}
