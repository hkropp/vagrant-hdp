import json, sys, urllib2, time, base64

class AmbariApiMonitor:

    def __init__(self, json_input=None, poll_interval=5.0):
        self.json_input = '{}'
        if json_input is not None:
            self.json_input = json_input
        self.poll_interval = poll_interval
        self.call_back_url = ''

        self.set_call_back_url()

    def set_json_input(self, json_input):
            self.json_input = json_input

    def set_call_back_url(self):
        if self.json_input is not None:
            self.call_back_url = self.json_input["href"]

    def get_call_back_url(self):
        return self.call_back_url

    def poll(self, poll_interval=None):
        if poll_interval is not None:
            p = poll_interval
        else:
            p = self.poll_interval

        while True:
            progress = "0"
            status, progress = self.get_status()
            if status =='COMPLETED':
                print "%s Operation completed" % (time.strftime("%Y-%m-%d %H:%M"))
                return 0
            elif status == 'InProgress' or status == 'PENDING' or status == 'IN_PROGRESS':
                print "%s Still running... Currently: %.2f percent complete" % (time.strftime("%Y-%m-%d %H:%M"), float(progress))
                time.sleep(p)
                continue
            else:
                print "%s something went wrong. Ambari Status code: %s" % (time.strftime("%Y-%m-%d %H:%M"), status)
                return 1

    def get_status(self):
        request = urllib2.Request(self.call_back_url)
        base64string = base64.encodestring('%s:%s' % ('admin', 'admin')).replace('\n', '')
        request.add_header("Authorization", "Basic %s" % base64string)
        raw_json = urllib2.urlopen(request)
        good_json = json.load(raw_json)
        status = good_json[u'Requests'][u'request_status']
        progress = good_json[u'Requests'][u'progress_percent']
        return status, progress

    def pretty_exit(self):
        pass


if __name__ == '__main__':
    raw_json = sys.stdin
    resultant_json = json.load(raw_json)
    b = AmbariApiMonitor(json_input=resultant_json)
    sys.exit(b.poll())