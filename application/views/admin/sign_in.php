<?php
defined('BASEPATH') OR exit('No direct script access allowed');

$flashdata = $this->session->flashdata('flashdata');

$this->load->view('partials/head');
?>

Halaman login Admin<br>
<a href="/staff/sign_in">Login sebagai Staff</a>

<br>
<br>

<?php echo form_open(base_url() . 'admin/sign_in'); ?>
<?php if ($flashdata && ($msg = $flashdata['msg'])): ?>
<br>
<?php echo $msg; ?>
<br>
<?php endif; ?>

<input type="text" placeholder="username" name="username">
<br>
<input type="password" placeholder="password" name="password">
<br>
<input type="submit" value="masuk">
</form>

