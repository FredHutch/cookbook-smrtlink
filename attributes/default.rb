default['smrtlink']['user'] = {
  'username' => 'smrtlink',
  'home' => '/home/smrtlink',
  'manage_user' => false
}
default['smrtlink']['service']['reload'] = false
# default['smrtlink']['local_dirs'] => {
#  '/nfs/smrtlink/userdata/db_datadir' => {
#    'target' => '/var/tmp/smrtlink/db_datadir',
#    'link' => true
# }
default['smrtlink']['paths']['SMRT_ROOT'] = '/home/smrtlink'
